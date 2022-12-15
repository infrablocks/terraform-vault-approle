# frozen_string_literal: true

require 'spec_helper'

describe 'full' do
  let(:component) do
    var(role: :full, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :full, name: 'deployment_identifier')
  end

  before(:context) do
    apply(role: :full)
  end

  after(:context) do
    destroy(
      role: :full,
      only_if: -> { !ENV['FORCE_DESTROY'].nil? || ENV['SEED'].nil? }
    )
  end

  describe 'approle' do
    let(:expected_role_name) do
      "service-#{component}-#{deployment_identifier}"
    end

    it 'creates a role using the component and deployment identifier as name ' \
       'using the default backend' do
      expect(Vault.approle.roles)
        .to(include(expected_role_name))
    end

    it 'outputs the role name' do
      expect(output(role: :full, name: 'role_name'))
        .to(eq(expected_role_name))
    end

    it 'outputs the role ID' do
      role_id = Vault.approle.role_id(expected_role_name)

      expect(output(role: :full, name: 'role_id'))
        .to(eq(role_id))
    end

    it 'uses a token TTL of 300' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:token_ttl]).to(eq(300))
    end

    it 'uses a token max TTL of 600' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:token_max_ttl]).to(eq(600))
    end

    it 'uses a token explicit max TTL of 900' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:token_explicit_max_ttl]).to(eq(900))
    end

    it 'uses a token num uses of 10' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:token_num_uses]).to(eq(10))
    end

    it 'uses a token period of 300' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:token_period]).to(eq(300))
    end

    it 'associates provided policies to generated tokens' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:token_policies])
        .to(eq(['some', 'policies']))
    end

    it 'uses a token type of "default"' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:token_type]).to(eq('default'))
    end

    it 'uses the provided token bound CIDRs' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:token_bound_cidrs])
        .to(contain_exactly('10.1.0.0/16', '10.2.0.0/16'))
    end

    it 'requires a secret ID to be presented to login' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:bind_secret_id]).to(be(true))
    end

    it 'uses a secret ID TTL of 300' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:secret_id_ttl]).to(eq(300))
    end

    it 'uses a secret ID num uses of zero' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:secret_id_num_uses]).to(eq(10))
    end

    it 'has no secret ID bound CIDRs' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:secret_id_bound_cidrs])
        .to(contain_exactly('10.1.0.0/16', '10.2.0.0/16'))
    end
  end

  describe 'secret IDs' do
    let(:expected_role_name) do
      "service-#{component}-#{deployment_identifier}"
    end

    let(:secret_id_properties) do
      Vault.approle.secret_id(
        expected_role_name, output(role: :full, name: 'default_secret_id')
      )
    end

    it 'creates a default secret ID for the role using the default backend' do
      secret_id_accessors =
        Vault.approle.secret_id_accessors(expected_role_name)

      expect(secret_id_accessors.count).to(eq(1))
    end

    it 'uses the provided CIDR list' do
      expect(secret_id_properties.data[:cidr_list])
        .to(contain_exactly('10.1.0.0/16', '10.2.0.0/16'))
    end

    it 'adds the component to metadata' do
      expect(secret_id_properties.data[:metadata][:component])
        .to(eq(component))
    end

    it 'adds the deployment identifier to metadata' do
      expect(secret_id_properties.data[:metadata][:deployment_identifier])
        .to(eq(deployment_identifier))
    end

    it 'adds a label of "default" to metadata' do
      expect(secret_id_properties.data[:metadata][:label])
        .to(eq('default'))
    end
  end
end
