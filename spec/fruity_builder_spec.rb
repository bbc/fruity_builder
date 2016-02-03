require 'fruity_builder.rb'

describe FruityBuilder::IOS::Helper do
  it 'should detect when no project exists' do
    builder = FruityBuilder::IOS::Helper.new("#{Dir.pwd}/spec/project_files/no_project")
    expect(builder.has_project?).to be(false)
  end

  it 'should detect a single project' do
    builder = FruityBuilder::IOS::Helper.new("#{Dir.pwd}/spec/project_files/single_project")
    expect(builder.has_project?).to be(true)
  end

  it 'should error when no project exists' do
    builder = FruityBuilder::IOS::Helper.new("#{Dir.pwd}/spec/project_files/no_project")
    expect{builder.project}.to raise_error(FruityBuilder::HelperCommandError)
  end

  it 'should error when multiple projects exist' do
    builder = FruityBuilder::IOS::Helper.new("#{Dir.pwd}/spec/project_files/multiple_projects")
    expect{builder.project}.to raise_error(FruityBuilder::HelperCommandError)
  end
end