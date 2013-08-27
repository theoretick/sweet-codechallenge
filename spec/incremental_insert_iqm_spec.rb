
require_relative '../incremental_insert_iqm'
require 'rspec'

describe 'incremental_insert_iqm' do

  describe 'calculate identical data to v1' do

    it 'should equal incremental IQM using 100k dataset' do
      expect(incremental_insert_iqm()).to eq(458.82)
    end

    it 'should equal incremental IQM using 10k dataset' do
      expect(incremental_insert_iqm('data-short.txt')).to eq(357.13)
    end

  end


  describe 'insert_sort' do

    it 'should return first if given empty' do
      expect(insert_sort([],12)).to eq(0)
    end

  end

end
