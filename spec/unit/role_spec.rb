# frozen_string_literal: true

require 'spec_helper'

describe 'approle' do
  let(:component) do
    var(role: :root, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :root, name: 'deployment_identifier')
  end

  describe 'by default' do
    let(:expected_role_name) do
      "#{component}-#{deployment_identifier}"
    end

    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates a role' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .once)
    end

    it 'uses the component and deployment identifier as the role name' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(
                :role_name, expected_role_name
              ))
    end

    it 'uses the default backend' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:backend, 'approle'))
    end

    it 'outputs the role name' do
      expect(@plan)
        .to(include_output_creation(name: 'module_outputs')
              .with_value(including(:role_name)))
    end

    it 'outputs the role ID' do
      expect(@plan)
        .to(include_output_creation(name: 'module_outputs')
              .with_value(including(:role_id)))
    end

    it 'uses the default token TTL' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:token_ttl, a_nil_value))
    end

    it 'uses the default token max TTL' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:token_max_ttl, a_nil_value))
    end

    it 'uses the default token explicit max TTL' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:token_explicit_max_ttl, a_nil_value))
    end

    it 'uses the default token num uses' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:token_num_uses, a_nil_value))
    end

    it 'uses the default token period' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:token_period, a_nil_value))
    end

    it 'associates no policies to generated tokens' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:token_policies, a_nil_value))
    end

    it 'uses a token type of "default" by default' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:token_type, 'default'))
    end

    it 'has no token bound CIDRs' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:token_bound_cidrs, a_nil_value))
    end

    it 'requires a secret ID to be presented to login' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:bind_secret_id, true))
    end

    it 'uses the default secret ID TTL' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:secret_id_ttl, a_nil_value))
    end

    it 'uses the default secret ID num uses' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:secret_id_num_uses, a_nil_value))
    end

    it 'has no secret ID bound CIDRs' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:secret_id_bound_cidrs, a_nil_value))
    end
  end

  describe 'when role name specified' do
    def role_name
      'some-role'
    end

    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.role_name = role_name
      end
    end

    it 'uses the supplied role name' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:role_name, role_name))
    end
  end

  describe 'when role prefix specified' do
    def role_name_prefix
      'some-role'
    end

    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.role_name_prefix = role_name_prefix
      end
    end

    it 'uses the supplied role name prefix along with the component and ' \
       'deployment identifier to construct the role name' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(
                :role_name,
                "#{role_name_prefix}-#{component}-#{deployment_identifier}"
              ))
    end
  end

  describe 'when backend specified' do
    def backend
      output(role: :prerequisites, name: 'services_approle_path')
    end

    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.backend = backend
      end
    end

    it 'uses the provided backend' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:backend, backend))
    end
  end

  describe 'when token TTL specified' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.token_ttl = 300
      end
    end

    it 'uses the provided token TTL' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:token_ttl, 300))
    end
  end

  describe 'when token max TTL specified' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.token_max_ttl = 600
      end
    end

    it 'uses the provided token max TTL' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:token_max_ttl, 600))
    end
  end

  describe 'when token explicit max TTL specified' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.token_explicit_max_ttl = 900
      end
    end

    it 'uses the provided token explicit max TTL' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:token_explicit_max_ttl, 900))
    end
  end

  describe 'when token num uses specified' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.token_num_uses = 10
      end
    end

    it 'uses the provided token num uses' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:token_num_uses, 10))
    end
  end

  describe 'when token period specified' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.token_period = 300
      end
    end

    it 'uses the provided token num uses' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:token_period, 300))
    end
  end

  describe 'when token policies specified' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.token_policies = %w[some policies]
      end
    end

    it 'uses the provided token policies' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(
                :token_policies, containing_exactly('some', 'policies')
              ))
    end
  end

  describe 'when token bound CIDRs specified' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.token_bound_cidrs = %w[10.1.0.0/16 10.2.0.0/16]
      end
    end

    it 'uses the provided token bound cidrs' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(
                :token_bound_cidrs,
                containing_exactly('10.1.0.0/16', '10.2.0.0/16')
              ))
    end
  end

  describe 'when token type specified' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.token_type = 'batch'
      end
    end

    it 'uses the provided token type' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:token_type, 'batch'))
    end
  end

  describe 'when bind secret ID specified' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.bind_secret_id = false
      end
    end

    it 'uses the provided token type' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:bind_secret_id, false))
    end
  end

  describe 'when secret ID TTL specified' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.secret_id_ttl = 300
      end
    end

    it 'uses the provided secret ID TTL' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:secret_id_ttl, 300))
    end
  end

  describe 'when secret ID bound CIDRs specified' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.secret_id_bound_cidrs = %w[10.1.0.0/16 10.2.0.0/16]
      end
    end

    it 'uses the provided secret ID bound CIDRs' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(
                :secret_id_bound_cidrs,
                containing_exactly('10.1.0.0/16', '10.2.0.0/16')
              ))
    end
  end

  describe 'when secret ID num uses specified' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.secret_id_num_uses = 10
      end
    end

    it 'uses the provided secret ID num uses' do
      expect(@plan)
        .to(include_resource_creation(type: 'vault_approle_auth_backend_role')
              .with_attribute_value(:secret_id_num_uses, 10))
    end
  end
end
