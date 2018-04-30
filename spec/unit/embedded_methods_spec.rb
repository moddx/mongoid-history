require 'spec_helper'

describe Mongoid::History::Trackable do
  describe 'EmbeddedMethods' do
    describe 'relation_class_of' do
      before :all do
        ModelOne = Class.new do
          include Mongoid::Document
          include Mongoid::History::Trackable
          embeds_one :emb_one, class_name: 'EmbOne'
          embeds_one :emb_two, store_as: 'emt', class_name: 'EmbTwo'
          track_history
        end

        EmbOne = Class.new do
          include Mongoid::Document
          embedded_in :model_one
        end

        EmbTwo = Class.new do
          include Mongoid::Document
          embedded_in :model_one
        end
      end

      it { expect(ModelOne.relation_class_of('emb_one')).to eq EmbOne }
      it { expect(ModelOne.relation_class_of('emt')).to eq EmbTwo }
      it { expect(ModelOne.relation_class_of('invalid')).to be_nil }

      after :all do
        Object.send(:remove_const, :ModelOne)
        Object.send(:remove_const, :EmbOne)
        Object.send(:remove_const, :EmbTwo)
      end
    end

    describe 'relation_class_of' do
      before :all do
        ModelOne = Class.new do
          include Mongoid::Document
          include Mongoid::History::Trackable
          embeds_many :emb_ones, class_name: 'EmbOne'
          embeds_many :emb_twos, store_as: 'emts', class_name: 'EmbTwo'
          track_history
        end

        EmbOne = Class.new do
          include Mongoid::Document
          embedded_in :model_one
        end

        EmbTwo = Class.new do
          include Mongoid::Document
          embedded_in :model_one
        end
      end

      it { expect(ModelOne.relation_class_of('emb_ones')).to eq EmbOne }
      it { expect(ModelOne.relation_class_of('emts')).to eq EmbTwo }
      it { expect(ModelOne.relation_class_of('invalid')).to be_nil }

      after :all do
        Object.send(:remove_const, :ModelOne)
        Object.send(:remove_const, :EmbOne)
        Object.send(:remove_const, :EmbTwo)
      end
    end
  end
end
