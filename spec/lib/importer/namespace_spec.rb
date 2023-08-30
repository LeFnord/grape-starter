# frozen_string_literal: false

RSpec.describe Starter::Importer::Namespace do
  let(:resource) { 'Foo' }
  let(:naming) { Starter::Names.new('Foo') }
  let(:paths) { { '/' => {} } }
  let(:components) { {} }

  describe 'sets class and namespace' do
    subject { described_class.new(naming: naming, paths: paths, components: components).content }

    specify do
      expect(subject).to include 'class Foo < Grape::API'
      expect(subject).to include 'namespace :foo do'
    end
  end

  describe '#prepare_route' do
    subject do
      ns = described_class.new(naming: naming, paths: {}, components: {})
      ns.send(:prepare_route, path)
    end

    describe 'no path params' do
      describe '/' do
        let(:path) { '/' }

        specify do
          expect(subject).to eql '/'
        end
      end

      describe '/a' do
        let(:path) { '/a' }

        specify do
          expect(subject).to eql '/a'
        end
      end

      describe '/a/b' do
        let(:path) { '/a/b' }

        specify do
          expect(subject).to eql '/a/b'
        end
      end
    end

    describe 'path params' do
      describe '/{a}' do
        let(:path) { '/{a}' }

        specify do
          expect(subject).to eql '/:a'
        end
      end

      describe '/a' do
        let(:path) { '/a/{b}' }

        specify do
          expect(subject).to eql '/a/:b'
        end
      end

      describe '/a/{b}/c' do
        let(:path) { '/a/{b}/c' }

        specify do
          expect(subject).to eql '/a/:b/c'
        end
      end

      describe '/a/{b}/c/{d}' do
        let(:path) { '/a/{b}/c/{d}' }

        specify do
          expect(subject).to eql '/a/:b/c/:d'
        end
      end
    end
  end
end
