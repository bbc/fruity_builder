require 'fruity_builder/build_properties'

describe FruityBuilder::IOS::BuildProperties do
  before(:all) do
    @build = FruityBuilder::IOS::BuildProperties.new("#{Dir.pwd}/spec/project_files/test.pbxproj")
  end

  describe 'Project Properties -' do
    it 'should open project properties' do
      @build.open_project_properties
      expect(@build.properties).to be_kind_of(String)
      expect(@build.properties).not_to be_empty
    end

    it 'should save project properties' do
      expect(@build.save_project_properties).to eq(@build.properties.length)
    end
  end

  describe 'Development Team' do
    it 'should get the Development Team ID' do
      expect(@build.get_dev_teams).to eq(["A12345B678"])
    end

    it 'should replace the Development Team ID' do
      @build.replace_dev_team('B234567C89')
      expect(@build.get_dev_teams).to eq(['B234567C89'])
    end
  end

  describe 'Code Signing Identity' do
    it 'should get the Code Signing Identity' do
      expect(@build.get_code_signing_identities).to eq(["iPhone Developer: A N Other (123456ABC7)", "iPhone Distribution: ACME CORP"])
    end

    it 'should replace the Code Signing Identity' do
      @build.replace_code_sign_identity('iPhone Developer: BBC')
      expect(@build.get_code_signing_identities).to eq(['iPhone Developer: BBC'])
    end
  end

  describe 'Provisioning Profile' do
    it 'should get the Provisioning Profile' do
      expect(@build.get_provisioning_profiles).to eq(["abcdefa1-bc23-4567-defa-bc89d01234e5", "a1234b5c-def6-7abc-8d9e-0123fa4b567c"])
    end

    it 'should replace the Provisioning Profile' do
      @build.replace_provisioning_profile('1234567-abc-1234-abcd-123456')
      expect(@build.get_provisioning_profiles).to eq(['1234567-abc-1234-abcd-123456'])
    end
  end
end