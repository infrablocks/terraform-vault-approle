# frozen_string_literal: true

require 'spec_helper'

describe 'secret IDs' do
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

    let(:secret_id_properties) do
      Vault.approle.secret_id(
        expected_role_name, output(:root, 'default_secret_id')
      )
    end

    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates a secret ID' do
      expect(@plan)
        .to(include_resource_creation(
              type: 'vault_approle_auth_backend_role_secret_id'
            )
              .once)
    end

    it 'associates it with the created role' do
      expect(@plan)
        .to(include_resource_creation(
              type: 'vault_approle_auth_backend_role_secret_id'
            )
              .with_attribute_value(
                :role_name, "#{component}-#{deployment_identifier}"
              ))
    end

    it 'uses the default backend' do
      expect(@plan)
        .to(include_resource_creation(
              type: 'vault_approle_auth_backend_role_secret_id'
            )
              .with_attribute_value(:backend, 'approle'))
    end

    it 'uses an empty CIDR list' do
      expect(@plan)
        .to(include_resource_creation(
              type: 'vault_approle_auth_backend_role_secret_id'
            )
              .with_attribute_value(:cidr_list, a_nil_value))
    end

    it 'adds the component to metadata' do
      expect(@plan)
        .to(include_resource_creation(
              type: 'vault_approle_auth_backend_role_secret_id'
            )
              .with_attribute_value(
                :metadata,
                matching(/"component":"#{component}"/)
              ))
    end

    it 'adds the deployment identifier to metadata' do
      expect(@plan)
        .to(include_resource_creation(
              type: 'vault_approle_auth_backend_role_secret_id'
            )
              .with_attribute_value(
                :metadata,
                matching(/"deployment_identifier":"#{deployment_identifier}"/)
              ))
    end

    it 'adds a label of "default" to metadata' do
      expect(@plan)
        .to(include_resource_creation(
              type: 'vault_approle_auth_backend_role_secret_id'
            )
              .with_attribute_value(
                :metadata,
                matching(/"label":"default"/)
              ))
    end
  end

  describe 'when secret ID bound CIDRs specified' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.default_secret_id_cidr_list = %w[10.1.0.0/16 10.2.0.0/16]
      end
    end

    it 'uses the provided CIDR list' do
      expect(@plan)
        .to(include_resource_creation(
              type: 'vault_approle_auth_backend_role_secret_id'
            )
              .with_attribute_value(
                :cidr_list, containing_exactly('10.1.0.0/16', '10.2.0.0/16')
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
        .to(include_resource_creation(
              type: 'vault_approle_auth_backend_role_secret_id'
            )
              .with_attribute_value(:backend, backend))
    end
  end
end
