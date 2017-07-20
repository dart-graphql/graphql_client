# High Level Roadmap

This purpose of this library is to offer as many GraphQL features in a short amount of time.
It is based on the official [spec][1]. The list of supported features are listed here.
Potential but bot critic features are also listed here.

## Library components

Here is a basic list of library's components.

- `GraphQLClient`: Used to instantiate a GraphQL client using a **network transport**.
This client is almost the only thing that you need to use. It posts request to a **graphql endpont** using a 
GQL query you built and is handling reconciliation between the HTTP response and the query type.
- `QueryBuilder`: Used to transform a GQL query into a string
- `QueryReconcilier`: Used to transform an HTTP response into a GQL populated query

## Roadmap
- `QueryBuilder`:
  - [ ] Builder
  - [x] Fields
  - [x] Arguments
  - [ ] Aliases
  - [x] Fragments
  - [ ] Variables
  - [x] Directives
  - [x] **Optionnal** Inline Fragments
- `VariableBuilder`:
  - [ ] Builder
- `MutationBuilder`:
  - [ ] Builder
  - [ ] Arguments
  - [ ] Variables
- `QueryReconcilier`:
  - [ ] Reconciler
  - [ ] Reconcile Aliases
- `Scalar Types`:
  - [ ] Implements default types
- `GraphQLAnnotations` (used to define queries and mutations):
  - [ ] Field arguments
  - [ ] Field directive
  - [ ] Field alias
- `GraphQLClient`:
  - [x] Factory
  - [ ] GraphQL Response
- [ ] **Optionnal** GraphQL dart classes generation from a GQL schema
- [x] **Optionnal** Translate GQL queries from String to `graphql_client` DSL
   
[1]: http://facebook.github.io/graphql/