chef-davical Cookbook
=====================
Installs and configures davical on to a server

Requirements
------------
#### Cookbooks
- `firewall` - to open up the server to TCP connections through port 80
- `apt` - update the apt-cache

#### Operating systems
Ubuntu

Attributes
----------

#### chef-davical::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>[:davical][:server_name]</tt></td>
    <td>String</td>
    <td>Server name that the nginx configuration responds to</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>[:davical][:system_name]</tt></td>
    <td>String</td>
    <td>The name of the application that delegates to Davical</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>[:davical][:system_email]</tt></td>
    <td>String</td>
    <td>The email account from which iCal reminders are sent</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>[:davical][:time_zone]</tt></td>
    <td>String</td>
    <td>Calendar time zone</td>
    <td><tt>Europe/London</tt></td>
  </tr>
</table>

Usage
-----
#### chef-davical::default

Just include `chef-davical` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[chef-davical]"
  ]
}
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_feature_f`)
3. Write tests for your change
4. Write your change
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Hemal N Varambhia
