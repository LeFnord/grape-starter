# frozen_string_literal: true

# RSpec.shared_examples 'help output' do |command|
#   if command
#     command "grape-starter #{command} -h"
#     its(:stdout) { is_expected.to include 'NAME' }
#     its(:stdout) { is_expected.to include 'SYNOPSIS' }
#     its(:stdout) { is_expected.to include 'COMMAND OPTIONS' }
#   else
#     command 'grape-starter -h'
#     its(:stdout) { is_expected.to include 'NAME' }
#     its(:stdout) { is_expected.to include 'SYNOPSIS' }
#     its(:stdout) { is_expected.to include 'VERSION' }
#     its(:stdout) { is_expected.to include 'GLOBAL OPTIONS' }
#     its(:stdout) { is_expected.to include 'COMMANDS' }
#   end
# end
