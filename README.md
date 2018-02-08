# static-sizeof

[![CircleCI](https://circleci.com/gh/TerrorJack/static-sizeof/tree/master.svg?style=shield)](https://circleci.com/gh/TerrorJack/static-sizeof/tree/master)
[![AppVeyor](https://ci.appveyor.com/api/projects/status/github/TerrorJack/static-sizeof?branch=master&svg=true)](https://ci.appveyor.com/project/TerrorJack/static-sizeof?branch=master)

A type-level `SizeOf`. Useful for implementing bound-safe binary serializers/parsers.

## Motivation

In a recent project, I was writing binary serializers/parsers for lots of message types. The most convenient (and probably fastest) method to parse a message is to directly slice a `ByteString`, instead of going through a monadic parser. Unfortunately, out-of-bound errors can easily occur if you do not keep the schema of message in your working memory.

So, let's keep the offsets and lengths at the type level, rather than the vulnerable brain. Here is a super simple open type family:

```haskell
type family SizeOf t :: Nat
```

Which is the point of this package. Instances for simple `Storable` types in `base` are present. When working with messages and buffers, one should:

* Provide instance of `SizeOf` for message fields, and message itself
* When working with buffers, add a phantom type which indicates buffer size

I wonder if some degree of automation is possible here. Possibly via `GHC.Generics` but only for product types?

Thoughts and suggestions are welcome.
