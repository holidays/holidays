$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__), '../'))
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__), '../lib/'))
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__), '../../lib/'))

$KCODE = 'u'

require 'rubygems'
require 'test/unit'
require 'date'
require 'holidays'
require 'holidays/ca'
