# Copyright 2011 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This code implements a no-op auth plugin, which allows users to use
# gsutil for accessing publicly readable buckets and objects without first
# signing up for an account.

from boto.auth_handler import AuthHandler


class NoOpAuth(AuthHandler):

  capability = ['s3']

  def __init__(self, path, config, provider):
    pass

  def add_auth(self, http_request):
    pass
