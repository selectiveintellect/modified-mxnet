# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

die "you need to define MXNET_DIR environment variable to point to a compiled version of MXNet" unless $ENV{MXNET_DIR};
die "Did not find a compiled version of libmxnet.so" unless -e "$ENV{MXNET_DIR}/lib/libmxnet.so";
use ExtUtils::MakeMaker;
use Alien::SWIG4;
use Env qw(@PATH);
use File::Which qw(which);
if (Alien::SWIG4->install_type ne 'system' and defined Alien::SWIG4->bin_dir) {
    unshift @PATH, Alien::SWIG4->bin_dir;
}
die "SWIG 4.0 or greater version needs to be used" if (Alien::SWIG4->version !~ /^4.\d+/);
my $swig_exe = which('swig');
print "Found swig executable at $swig_exe\n";
my @swig_args = ($swig_exe, '-Wall', '-noproxy', '-c++', '-perl5', '-I.', 'nnvm.i');
my $cxx_file = 'nnvm_wrap.cxx';
my $ret = system(@swig_args);
if ($ret == 0 and -e $cxx_file) {
    print "Successfully generated $cxx_file\n";
    unlink "NNVMCAPI.pm" or warn "Cannot delete NNVMCAPI.pm file";
} else {
    die "Failed to successfully generate $cxx_file from $swig_exe";
}
my @tmp = split(/ /, $ExtUtils::MakeMaker::Config{lddlflags});
my @lddlflags;
while(my $flag = shift(@tmp))
{
   if($flag eq '-arch')
   {
      my $arch = shift(@tmp);
      if($arch eq 'i386')
      {
         next;
      }
      else
      {
         push @lddlflags, ($flag, $arch);
      }
   }
   else
   {
      push @lddlflags, $flag;
   }
}
push @lddlflags, "-L$ENV{MXNET_DIR}/lib" if defined $ENV{MXNET_DIR} and -d "$ENV{MXNET_DIR}/lib";
print "LDDLFLAGS: " . join(' ', @lddlflags) . "\n";

WriteMakefile(
    NAME            => 'AI::NNVMCAPI',
    LICENSE         => 'apache_2_0',
    AUTHOR          => 'Sergey Kolychev <sergeykolychev.github@gmail.com>',
    VERSION_FROM    => 'lib/AI/NNVMCAPI.pm',
    ABSTRACT_FROM   => 'lib/AI/NNVMCAPI.pm',
    LIBS           => ["-L$ENV{MXNET_DIR}/lib -lmxnet"],
    INC            => "-I$ENV{MXNET_DIR}/include/nnvm",
    OBJECT         => 'nnvm_wrap.o',
    LDDLFLAGS      => join(' ', @lddlflags),
    PREREQ_PM      => {
        # prereqs
        # build/test prereqs
        'Test::More'   => 0,
        'Env' => 0,
        'Alien::SWIG4' => 0,
        'File::Which' => 0,
    },
    PL_FILES        => {},
);
