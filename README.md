rundeck-node
========

This cookbook configures a Rundeck node to be used with Rundeck server.

See the rundeck-server cookbook.

New configuration options will be added as needed.

Requirements
------------

This cookbook requires chef >=11.10

Usage
-----

Include default recipe in a role or as a dependency in a wrapper cookbook.

With default attribute values, the default recipe will create a local user used by rundeck server to interact with the node. User will be sudoer/Administrator and have no password (except on windows) nor public key.

### Attributes

We recommend to use `node['rundeck_node']['auth_public_key']` to set up a public key that can be used to connect without any password.

Attribute            | Description                         | Type                  | Default
---------------------|-------------------------------------|-----------------------|--------
`account`            | Account type for rundeck user       | String (local\|domain) | `'local'`
`user`               | User name for rundeck user          | String                | `'rundeck'`
`group`              | Group name for rundeck user         | String                | depends on platform
`home`               | Home dir for rundeck user           | String                | depends on platform
`user_password_file` | password path                       | String                | `nil`
`user_password`      | hard coded password (_insecure_)    | String                | `nil`
`keepass_version`    | keepass gem version                 | String                | `nil`
`auth.key`           | activate public key authentication  | Boolean               | `true`
`auth_public_key`    | authorized public key               | String                | `nil`

Contributing
------------
1. Fork the [repository on Github][repository]
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

```text
Copyright 2014, Criteo.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

[repository]:               https://github.com/criteo-cookbooks/rundeck-node
