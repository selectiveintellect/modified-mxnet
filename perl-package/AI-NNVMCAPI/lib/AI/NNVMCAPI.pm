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

package AI::NNVMCAPI;
use strict;
use base qw(DynaLoader);
bootstrap AI::NNVMCAPI;
our $VERSION = '1.5';
1;
__END__

=head1 NAME

AI::NNVMCAPI - Swig interface to nnvm c api

=head1 SYNOPSIS

 use AI::NNVMCAPI;

=head1 DESCRIPTION

This module provides interface to nnvm
via its api.

=head1 SEE ALSO

L<AI::MXNet>

=head1 AUTHOR

Sergey Kolychev, <sergeykolychev.github@gmail.com>

=head1 COPYRIGHT & LICENSE

This library is licensed under Apache 2.0 license.

See https://www.apache.org/licenses/LICENSE-2.0 for more information.

=cut
