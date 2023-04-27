# frozen_string_literal: false

RSpec.describe Starter::Build do
  let(:single) { 'foo' }
  let(:plural) { 'foos' }

  subject { described_class }

  specify { expect(subject).to respond_to :resource }
  specify { expect(subject).to respond_to :set }
  specify { expect(subject).to respond_to :force }
  specify { expect(subject).to respond_to :entity }
  specify { expect(subject).to respond_to :destination }

  describe 'public methods' do
    it { is_expected.to respond_to :new! }
    it { is_expected.to respond_to :add! }
    it { is_expected.to respond_to :remove! }
  end

  describe '#new call' do
    subject do
      starter_gem = Gem::Specification.find_by_name('grape-starter').gem_dir
      src = File.join(starter_gem, 'template', '.')
      dest = "tmp/#{single}"
      described_class.new!(single, src, dest, p: 'awesome_api')
    end

    let!(:created_api) { File.join(Dir.getwd, subject.destination) }

    after do
      FileUtils.remove_dir(created_api, true)
    end

    describe 'Names methods' do
      specify { expect(subject.naming.klass_name).to eql 'Foo' }
      specify { expect(subject.naming.resource_file).to eql 'foo.rb' }

      specify { expect(subject.naming.api_file_name).to include 'api/endpoints/foo.rb' }
      specify { expect(subject.naming.lib_file_name).to include 'lib/models/foo.rb' }
      specify { expect(subject.naming.api_spec_name).to include 'spec/requests/foo_spec.rb' }
      specify { expect(subject.naming.lib_spec_name).to include 'spec/lib/models/foo_spec.rb' }
    end

    describe '#file_list' do
      describe 'standard' do
        let(:files) { subject.send(:file_list) }
        specify do
          expect(files).to eql %w[api_file lib_file api_spec lib_spec]
        end
      end

      describe 'standard plus entity' do
        before { subject.instance_variable_set(:@entity, true) }

        let(:files) { subject.send(:file_list) }
        specify do
          expect(files).to eql %w[api_file lib_file api_spec lib_spec entity_file]
        end
      end
    end

    describe '#should_raise?' do
      let(:file) { '/file/path' }
      before { subject.instance_variable_set(:@set, ['get']) }

      describe 'force false (default)' do
        describe 'file not exist' do
          specify { expect { subject.send(:should_raise?, file) }.not_to raise_error }
        end

        describe 'file exist' do
          before(:each) { allow(File).to receive(:exist?).with(file).and_return true }

          specify { expect { subject.send(:should_raise?, file) }.to raise_error '… resource exists' }
        end
      end

      describe 'force true' do
        before { subject.instance_variable_set(:@force, true) }

        describe 'file not exist' do
          specify { expect { subject.send(:should_raise?, file) }.not_to raise_error }
        end

        describe 'file exist' do
          before(:each) { allow(File).to receive(:exist?).with(file).and_return true }

          specify { expect { subject.send(:should_raise?, file) }.not_to raise_error }
        end
      end
    end
  end

  describe '#replace_static' do
    describe 'on new! call' do
      subject do
        starter_gem = Gem::Specification.find_by_name('grape-starter').gem_dir
        src = File.join(starter_gem, 'template', '.')
        dest = 'tmp/base'
        described_class.new!('Base', src, dest, p: 'awesome_api')
      end

      let!(:created_api) { File.join(Dir.getwd, subject.destination) }

      after do
        FileUtils.remove_dir(created_api, true)
      end

      describe 'API base file' do
        let(:base) { File.read(File.join(created_api, 'api', 'base.rb')) }

        describe 'sets prefix' do
          let(:expected_prefix) { "prefix :#{subject.prefix}" }
          specify do
            expect(base).to include expected_prefix
          end
        end
      end

      describe 'root spec' do
        let(:spec) { File.read(File.join(created_api, 'spec', 'requests', 'root_spec.rb')) }

        describe 'sets route' do
          let(:expected_route) { "/#{subject.prefix}/v1/root" }
          specify do
            expect(spec).to include expected_route
          end
        end
      end

      describe 'documentation spec' do
        let(:spec) { File.read(File.join(created_api, 'spec', 'requests', 'documentation_spec.rb')) }

        describe 'sets route' do
          let(:expected_route) { "/#{subject.prefix}/v1/oapi" }
          specify do
            expect(spec).to include expected_route
          end
        end
      end
    end
  end

  describe '#endpoint_set' do
    subject(:awesome_api) do
      starter_gem = Gem::Specification.find_by_name('grape-starter').gem_dir
      src = File.join(starter_gem, 'template', '.')
      dest = 'tmp/base'
      described_class.new!('Base', src, dest, p: 'awesome_api')
    end

    let!(:created_api) { File.join(Dir.getwd, awesome_api.destination) }

    after do
      FileUtils.remove_dir(created_api, true)
    end

    let(:set) { subject.send(:endpoint_set) }

    describe 'single' do
      subject do
        Dir.chdir(awesome_api.destination) do
          awesome_api.add!(single, options)
        end
        awesome_api
      end

      describe 'POST' do
        let(:options) { { set: ['post'] } }
        specify { expect(set).to eql [:post] }
      end

      describe 'GET' do
        let(:options) { { set: ['get'] } }
        specify { expect(set).to eql [:get_one] }
      end

      describe 'PUT' do
        let(:options) { { set: ['put'] } }
        specify { expect(set).to eql [:put_one] }
      end

      describe 'PATCH' do
        let(:options) { { set: ['patch'] } }
        specify { expect(set).to eql [:patch_one] }
      end

      describe 'DELETE' do
        let(:options) { { set: ['delete'] } }
        specify { expect(set).to eql [:delete_one] }
      end

      describe 'multinple given' do
        let(:options) { { set: %w[post get delete] } }
        specify { expect(set).to eql %i[post get_one delete_one] }
      end
    end

    describe 'plural' do
      subject do
        Dir.chdir(awesome_api.destination) do
          awesome_api.add!(plural, options)
        end
        awesome_api
      end

      describe 'POST' do
        let(:options) { { set: ['post'] } }
        specify { expect(set).to eql [:post] }
      end

      describe 'GET' do
        let(:options) { { set: ['get'] } }
        specify { expect(set).to eql %i[get_all get_specific] }
      end

      describe 'PUT' do
        let(:options) { { set: ['put'] } }
        specify { expect(set).to eql [:put_specific] }
      end

      describe 'PATCH' do
        let(:options) { { set: ['patch'] } }
        specify { expect(set).to eql [:patch_specific] }
      end

      describe 'DELETE' do
        let(:options) { { set: ['delete'] } }
        specify { expect(set).to eql [:delete_specific] }
      end

      describe 'multinple given' do
        let(:options) { { set: %w[post get delete] } }
        specify { expect(set).to eql %i[post get_all get_specific delete_specific] }
      end
    end
  end
end
