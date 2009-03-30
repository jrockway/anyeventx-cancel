use inc::Module::Install;

name 'AnyEventX-Cancel';
all_from 'lib/AnyEventX/Cancel.pm';

requires 'Sub::Exporter';
requires 'AnyEvent';

build_requires 'Test::More';
build_requires 'ok';

WriteAll();
