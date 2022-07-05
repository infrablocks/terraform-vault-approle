# frozen_string_literal: true

require 'spec_helper'

describe 'approle' do
  let(:component) { vars(:root).component }
  let(:deployment_identifier) { vars(:root).deployment_identifier }

  describe 'by default' do
    let(:expected_role_name) do
      "#{component}-#{deployment_identifier}"
    end

    before(:context) do
      provision(:root)
    end

    after(:context) do
      destroy(:root)
    end

    it 'creates a role using the component and deployment identifier as name ' \
       'using the default backend' do
      expect(Vault.approle.roles)
        .to(include(expected_role_name))
    end

    it 'uses a token TTL of zero' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:token_ttl]).to(eq(0))
    end

    it 'uses a token max TTL of zero' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:token_max_ttl]).to(eq(0))
    end

    it 'uses a token explicit max TTL of zero' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:token_explicit_max_ttl]).to(eq(0))
    end

    it 'uses a token num uses of zero' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:token_num_uses]).to(eq(0))
    end

    it 'uses a token period of zero' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:token_period]).to(eq(0))
    end

    it 'uses a token type of "default" by default' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:token_type]).to(eq('default'))
    end

    it 'has no token bound CIDRs' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:token_bound_cidrs]).to(eq([]))
    end

    it 'requires a secret ID to be presented to login' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:bind_secret_id]).to(be(true))
    end

    it 'uses a secret ID TTL of zero' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:secret_id_ttl]).to(eq(0))
    end

    it 'uses a secret ID num uses of zero' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:secret_id_num_uses]).to(eq(0))
    end

    it 'has no secret ID bound CIDRs' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:secret_id_bound_cidrs]).to(be_nil)
    end
  end

  describe 'when role name specified' do
    def role_name
      'some-role'
    end

    before(:context) do
      provision(:root) do |vars|
        vars.merge({ role_name: })
      end
    end

    after(:context) do
      destroy(:root)
    end

    it 'creates a role with the supplied role name' do
      expect(Vault.approle.roles).to(include(role_name))
    end
  end

  describe 'when role prefix specified' do
    def role_name_prefix
      'some-role'
    end

    before(:context) do
      provision(:root) do |vars|
        vars.merge({ role_name_prefix: })
      end
    end

    after(:context) do
      destroy(:root)
    end

    it 'creates a role with the supplied role prefix including the component ' \
       'and the deployment identifier' do
      roles = Vault.approle.roles
      role = roles.first { |r| r.include?(role_name_prefix) }

      expect(role).to(include(component).and(include(deployment_identifier)))
    end
  end

  describe 'when backend specified' do
    let(:backend) do
      output(:prerequisites, 'services_approle_path')
    end

    before(:context) do
      provision(:root) do |vars|
        vars.merge(
          {
            backend: output(:prerequisites, 'services_approle_path')
          }
        )
      end
    end

    after(:context) do
      destroy(:root)
    end

    it 'creates a role in the supplied backend' do
      roles = begin
        json = Vault.client.list("/v1/auth/#{backend}/role")
        Vault::Secret.decode(json).data[:keys] || []
      rescue Vault::HTTPError => e
        raise unless e.code == 404

        []
      end

      role_name_matcher = include(component)
                          .and(include(deployment_identifier))

      expect(roles).to(include(role_name_matcher))
    end
  end

  describe 'when token TTL specified' do
    let(:expected_role_name) do
      "#{component}-#{deployment_identifier}"
    end

    before(:context) do
      provision(:root) do |vars|
        vars.merge(
          {
            token_ttl: 300
          }
        )
      end
    end

    after(:context) do
      destroy(:root)
    end

    it 'uses the provided token TTL' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:token_ttl]).to(eq(300))
    end
  end

  describe 'when token max TTL specified' do
    let(:expected_role_name) do
      "#{component}-#{deployment_identifier}"
    end

    before(:context) do
      provision(:root) do |vars|
        vars.merge(
          {
            token_max_ttl: 600
          }
        )
      end
    end

    after(:context) do
      destroy(:root)
    end

    it 'uses the provided token max TTL' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:token_max_ttl]).to(eq(600))
    end
  end

  describe 'when token explicit max TTL specified' do
    let(:expected_role_name) do
      "#{component}-#{deployment_identifier}"
    end

    before(:context) do
      provision(:root) do |vars|
        vars.merge(
          {
            token_explicit_max_ttl: 900
          }
        )
      end
    end

    after(:context) do
      destroy(:root)
    end

    it 'uses the provided token explicit max TTL' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:token_explicit_max_ttl]).to(eq(900))
    end
  end

  describe 'when token num uses specified' do
    let(:expected_role_name) do
      "#{component}-#{deployment_identifier}"
    end

    before(:context) do
      provision(:root) do |vars|
        vars.merge(
          {
            token_num_uses: 10
          }
        )
      end
    end

    after(:context) do
      destroy(:root)
    end

    it 'uses the provided token num uses' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:token_num_uses]).to(eq(10))
    end
  end

  describe 'when token period specified' do
    let(:expected_role_name) do
      "#{component}-#{deployment_identifier}"
    end

    before(:context) do
      provision(:root) do |vars|
        vars.merge(
          {
            token_period: 300
          }
        )
      end
    end

    after(:context) do
      destroy(:root)
    end

    it 'uses the provided token num uses' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:token_period]).to(eq(300))
    end
  end

  describe 'when token bound CIDRs specified' do
    let(:expected_role_name) do
      "#{component}-#{deployment_identifier}"
    end

    before(:context) do
      provision(:root) do |vars|
        vars.merge(
          {
            token_bound_cidrs: %w[10.1.0.0/16 10.2.0.0/16]
          }
        )
      end
    end

    after(:context) do
      destroy(:root)
    end

    it 'uses the provided token bound cidrs' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:token_bound_cidrs])
        .to(eq(%w[10.1.0.0/16 10.2.0.0/16]))
    end
  end

  describe 'when token type specified' do
    let(:expected_role_name) do
      "#{component}-#{deployment_identifier}"
    end

    before(:context) do
      provision(:root) do |vars|
        vars.merge(
          {
            token_type: 'batch'
          }
        )
      end
    end

    after(:context) do
      destroy(:root)
    end

    it 'uses the provided token type' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:token_type])
        .to(eq('batch'))
    end
  end

  describe 'when bind secret ID specified' do
    let(:expected_role_name) do
      "#{component}-#{deployment_identifier}"
    end

    before(:context) do
      provision(:root) do |vars|
        vars.merge(
          {
            # required so that there is at least one constraint on the role
            token_bound_cidrs: ['10.0.0.0/8'],
            bind_secret_id: false
          }
        )
      end
    end

    after(:context) do
      destroy(:root)
    end

    it 'uses the provided bind secret ID value' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:bind_secret_id]).to(be(false))
    end
  end

  describe 'when secret ID TTL specified' do
    let(:expected_role_name) do
      "#{component}-#{deployment_identifier}"
    end

    before(:context) do
      provision(:root) do |vars|
        vars.merge(
          {
            secret_id_ttl: 300
          }
        )
      end
    end

    after(:context) do
      destroy(:root)
    end

    it 'uses the provided secret ID TTL' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:secret_id_ttl]).to(eq(300))
    end
  end

  describe 'when secret ID bound CIDRs specified' do
    let(:expected_role_name) do
      "#{component}-#{deployment_identifier}"
    end

    before(:context) do
      provision(:root) do |vars|
        vars.merge(
          {
            secret_id_bound_cidrs: %w[10.1.0.0/16 10.2.0.0/16]
          }
        )
      end
    end

    after(:context) do
      destroy(:root)
    end

    it 'uses the provided secret ID bound CIDRs' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:secret_id_bound_cidrs])
        .to(eq(%w[10.1.0.0/16 10.2.0.0/16]))
    end
  end

  describe 'when secret ID num uses specified' do
    let(:expected_role_name) do
      "#{component}-#{deployment_identifier}"
    end

    before(:context) do
      provision(:root) do |vars|
        vars.merge(
          {
            secret_id_num_uses: 10
          }
        )
      end
    end

    after(:context) do
      destroy(:root)
    end

    it 'uses the provided secret ID num uses' do
      role = Vault.approle.role(expected_role_name)

      expect(role.data[:secret_id_num_uses]).to(eq(10))
    end
  end
end
