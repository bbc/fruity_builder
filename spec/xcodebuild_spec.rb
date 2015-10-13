# get schemes
# get targets
# get build configurations
require 'fruity_builder/xcodebuild'

describe FruityBuilder::IOS::XCodeBuild do
  before(:all) do
    @builder = FruityBuilder::IOS::XCodeBuild.new('')
  end

  it 'should get the schemes' do
    output = <<eos
    Schemes:
      Calabash
      RSpec
eos

    allow(Open3).to receive(:capture3) {
      [output, '', (Struct.new(:exitstatus)).new(0)]
    }

    expect(@builder.get_schemes).to be_kind_of(Array)
    expect(@builder.get_schemes).to eq(['Calabash', 'RSpec'])
  end

  it 'should get the build targets' do
    output = <<eos
    Information about project "PickNMix":
      Targets:
      Calabash
      RSpec
eos

    allow(Open3).to receive(:capture3) {
      [output, '', (Struct.new(:exitstatus)).new(0)]
    }

    expect(@builder.get_targets).to be_kind_of(Array)
    expect(@builder.get_targets).to eq(['Calabash', 'RSpec'])
  end

  it 'should get the build configurations' do
    output = <<eos
    Build Configurations:
      Debug
      Release
      Calabash

    If no build configuration is specified and -scheme is not passed then "Release" is used.
eos
    allow(Open3).to receive(:capture3) {
      [output, '', (Struct.new(:exitstatus)).new(0)]
    }

    expect(@builder.get_build_configurations).to be_kind_of(Array)
    expect(@builder.get_build_configurations).to eq(['Debug', 'Release', 'Calabash'])

  end
end

