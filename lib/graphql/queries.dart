class Queries {
  static const String fetchAllLinks = r"""
    query Links {
        links {
            id
            title
            address
            user {
                id
                name
            }
        }
    }
  """;

  static const String login = r"""
    mutation Login($username: String!, $password: String!) {
      login(input: { username: $username, password: $password })
    }
  """;
}
