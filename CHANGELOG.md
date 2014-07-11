###0.3.0

Feature release

* Class parameter changes. See documentation for usage
  * New class parameter `notify_email` (boolean) to disable email notifications in a more consistent way
  * `debug_level` parameter now accepts value `-1` to also suppress deltarpm messages 
* Fixed permissions on module content, causing module upgrade to complain about changed files
    * NOTE: use the `--force` option to upgrade to this release
* Updated documentation

###0.2.0

OS support release

* Added support for Fedora 15+

###0.1.1

Minor enhancement release

* Move package exclusion logic from ERB templates to Puppet STL
* Added To Do documentation section
* Added this changelog
 
###0.1.0

First forge release