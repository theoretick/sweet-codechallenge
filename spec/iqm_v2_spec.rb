require_relative '../incremental_insert_iqm.rb'
require 'rspec'

describe 'incremental_insert_iqm' do

  it 'should calculate identical data to v1 incremental IQM using 100k dataset' do
    expect(incremental_insert_iqm()).to eq('100000: 458.82') # FULL 100k version
  end

  it 'should calculate identical data to v1 incremental IQM using 10k dataset' do
    expect(incremental_insert_iqm('data-short.txt')).to eq('10000: 357.13')
  end

end
