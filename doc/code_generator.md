# Code Generator

The purpose of this document is to describe how the code generator could work.

## Idea

My idea is to be able to write your GQL queries using the GQL language.
For instance write a file:

*MyAwesomeQuery.graphql*:
```graphql
query MyAwesomeQuery {
    viewer {
        login
        repositories(first: 5) {
            nodes {
                name
            }
        }
    }
}
```

Then you would run a dart transformer that reads all your graphql files and convert them
into the `graphql_client` dsl and store its output files into your project.

You would then use the dart query format. As it follows the initial graphql query format,
it would be really easy to use. 

This is how the [Apollo Swift client][swift_client] works.

## Implementation

* Create a dart transformer
* Read all `*.graphql` files
* Parse the GQL using a library like [this one][graphql_parser].
* Generate the corresponding dart code using the [code_builder][code_builder] library.

[swift_client]: http://dev.apollodata.com/ios/
[graphql_parser]: https://pub.dartlang.org/packages/graphql_parser
[code_builder]: https://github.com/dart-lang/code_builder