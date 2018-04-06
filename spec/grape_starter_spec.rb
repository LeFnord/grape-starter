# frozen_string_literal: true

RSpec.describe 'grape-starter' do
  describe 'version' do
    command 'grape-starter -v'
    its(:stdout) { is_expected.to include(Starter::VERSION) }
  end

  describe 'help' do
    it_behaves_like 'help output'

    describe 'sub commands' do
      command 'grape-starter -h'

      its(:stdout) { is_expected.to include 'add  - Adds given new resource' }
      its(:stdout) { is_expected.to include 'help - Shows a list of commands or help for one command' }
      its(:stdout) { is_expected.to include 'new  - Creates initial api skeleton' }
      its(:stdout) { is_expected.to include 'rm   - Removes given resource' }
    end
  end

  describe 'new' do
    it_behaves_like 'help output', 'new'

    describe 'options' do
      command 'grape-starter new -h'

      its(:stdout) { is_expected.to include '-o, --orm=arg' }
      its(:stdout) { is_expected.to include '-p, --prefix=arg' }
    end
  end

  describe 'add' do
    it_behaves_like 'help output', 'add'

    describe 'options' do
      command 'grape-starter add -h'

      its(:stdout) { is_expected.to include '-e, --entity' }
      its(:stdout) { is_expected.to include '-m, --migration' }
      its(:stdout) { is_expected.to include '-o, --orm' }
    end
  end

  describe 'rm' do
    it_behaves_like 'help output', 'rm'

    describe 'options' do
      command 'grape-starter rm -h'

      its(:stdout) { is_expected.to include '-e, --entity' }
    end
  end
end
