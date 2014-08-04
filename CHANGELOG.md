###0.3.3

* Make Puppet Doc compliant with RDoc markup language

###0.3.2

* Remove `email_from` feature from CentOS 5, since it is not supported
* Updated documentation

###0.3.1

* Adjust default `debug_level` depending on the platform
* `debug_level` is enforced to `-1` when `notify_email` is set to `false`
* Updated documentation
* Removed unused `download_only` parameter (leftover)

###0.3.0

* Class parameter changes. See documentation for usage
  * New class parameter `notify_email` (boolean) to disable email notifications in a more consistent way
  * `debug_level` parameter now accepts value `-1` to also suppress deltarpm messages 
* Fixed permissions on module content, causing module upgrade to complain about changed files
    * NOTE: use the `--force` option to upgrade to this release
* Updated documentation

###0.2.0

* Added support for Fedora 15+

###0.1.1

* Move package exclusion logic from ERB templates to Puppet STL
* Added To Do documentation section
* Added this changelog
 
###0.1.0

First forge release