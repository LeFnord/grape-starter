# frozen_string_literal: false

RSpec.describe Starter::Importer::Namespace do
  let(:resource) { 'Foo' }
  let(:paths) { { '/' => {} } }
  let(:components) { {} }

  describe 'sets class and namespace' do
    subject { described_class.new(resource: resource, paths: paths, components: components).file }

    specify do
      expect(subject).to include 'class Foo < Grape::API'
      expect(subject).to include 'namespace :foo do'
    end
  end

  describe '#prepare_route' do
    subject do
      ns = described_class.new(resource: resource, paths: {}, components: {})
      ns.send(:prepare_route, path)
    end

    describe 'no path params' do
      describe '/' do
        let(:path) { '/' }

        specify do
          expect(subject).to match_array ['/', false]
        end
      end

      describe '/a' do
        let(:path) { '/a' }

        specify do
          expect(subject).to match_array ['/a', false]
        end
      end

      describe '/a/b' do
        let(:path) { '/a/b' }

        specify do
          expect(subject).to match_array ['/a/b', false]
        end
      end
    end

    describe 'path params' do
      describe '/{a}' do
        let(:path) { '/{a}' }

        specify do
          expect(subject.first).to eql '/:a'
          expect(subject.last).to match_array ['a']
        end
      end

      describe '/a' do
        let(:path) { '/a/{b}' }

        specify do
          expect(subject.first).to eql '/a/:b'
          expect(subject.last).to match_array ['b']
        end
      end

      describe '/a/{b}/c' do
        let(:path) { '/a/{b}/c' }

        specify do
          expect(subject.first).to eql '/a/:b/c'
          expect(subject.last).to match_array ['b']
        end
      end

      describe '/a/{b}/c/{d}' do
        let(:path) { '/a/{b}/c/{d}' }

        specify do
          expect(subject.first).to eql '/a/:b/c/:d'
          expect(subject.last).to match_array %w[b d]
        end
      end
    end
  end

  describe '#route_params' do
    let(:params) { %w[b d] }

    subject do
      ns = described_class.new(resource: resource, paths: {}, components: {})
      ns.send(:route_params, params)
    end

    specify do
      lines = subject.split("\n")
      expect(lines[0]).to include 'params do'
      expect(lines[1]).to include 'requires :b'
      expect(lines[2]).to include 'requires :d'
      expect(lines[3]).to include 'end'
    end
  end
end
