require 'fruity_builder/plistutil'

describe FruityBuilder::Plistutil do
  describe 'Bundle ID -' do
    it 'should get the bundle ID' do
      bundle_ids = FruityBuilder::Plistutil.get_bundle_id(xml: File.read("#{Dir.pwd}/spec/project_files/info.plist"))
      expect(bundle_ids).to eq(["uk.co.bbc.testapp", "$(PRODUCT_NAME)"])
    end

    it 'should replace the bundle ID' do
      new_plist = FruityBuilder::Plistutil.replace_bundle_id(xml: File.read("#{Dir.pwd}/spec/project_files/info.plist"), new_id: 'uk.co.bbc.test')
      expect(FruityBuilder::Plistutil.get_bundle_id(xml: new_plist)).to eq(["uk.co.bbc.test"])
    end
  end
end