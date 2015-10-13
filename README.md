# Fruity Builder

Code manipulation tools for iOS code bases.

## Usage

Initialise with a path to the project folder:

```ruby
builder = FruityBuilder::IOS::Helper.new(path)
```

### Replacing build properties

```ruby
builder.build.replace_dev_team('New dev team')
builder.build.replace_code_sign_identity('New identity')
builder.build.replace_provisioning_profile('New profile')
builder.build.save_project_properties
builder.build.replace_bundle_id('New bundle ID')
```

### Retrieving build properties

```ruby
builder.build.get_dev_teams # ['Dev Team']
builder.build.get_code_signing_identities # ['Identity 1', 'Identity 2']
builder.build.get_provisioning_profiles # ['Profile 1', 'Profile 2']
```

### Retrieving build configurations

```ruby
builder.xcode.get_schemes # ['Scheme 1', 'Scheme 2']
builder.xcode.get_build_configurations # ['Debug', 'Release', 'Test']
builder.xcode.get_target # ['Target 1', 'Target 2']
```
