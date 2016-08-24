require 'spec_helper'

RSpec.describe Starter::Printer do
  describe 'welcome' do
    subject { described_class.call(base_message) }

    describe 'empty base_message' do
      let(:base_message) { '' }

      it { expect(subject).not_to be_empty }
    end

    describe 'given base_message' do
      let(:ori_message) { 'somewhere over the rainbow' }
      let(:base_message) { ori_message }

      it { expect(subject).to eql ori_message }
    end
  end
end
