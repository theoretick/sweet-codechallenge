require_relative '../lib/iqm_v2.rb'
require 'rspec'

describe 'incremental interquartile mean take_2' do

  it 'should calculate identical data as v1' do
    expect(iqm_v2()).to eq('100000: 458.82') # FULL 100k version
  end
  it 'should calculate identical data to short-set' do
    expect(iqm_v2('data-short.txt')).to eq('10000: 357.13') # 10k version
  end

end