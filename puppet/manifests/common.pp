# common.pp - common definitions which are independent of the system and load
# some central modules

# don't distribute version control metadata
File { ignore => ['.svn', '.git', 'CVS' ] }

package { ['locate', 'mlocate', 'popularity-contest']: ensure => absent }

