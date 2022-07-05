# frozen_string_literal: true

require 'spec_helper'

describe 'secret IDs' do
  let(:component) { vars(:root).component }
  let(:deployment_identifier) { vars(:root).deployment_identifier }

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
      provision(:root)
    end

    after(:context) do
      destroy(:root)
    end

    it 'creates a default secret ID for the role using the default backend' do
      secret_id_accessors =
        Vault.approle.secret_id_accessors(expected_role_name)

      expect(secret_id_accessors.count).to(eq(1))
    end

    it 'uses an empty CIDR list' do
      expect(secret_id_properties.data[:cidr_list]).to(be_empty)
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

  describe 'when backend specified' do
    let(:backend) do
      output(:prerequisites, 'services_approle_path')
    end

    let(:expected_role_name) do
      "#{component}-#{deployment_identifier}"
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

    it 'creates a default secret ID for the role in the supplied backend' do
      secret_id_properties = begin
        opts = { secret_id: output(:root, 'default_secret_id') }
        path = "/v1/auth/#{backend}/role/#{expected_role_name}/secret-id/lookup"
        json = Vault.client.post(path, JSON.fast_generate(opts), {})
        Vault::Secret.decode(json) || nil
      rescue Vault::HTTPError => e
        raise unless e.code == 404

        nil
      end

      expect(secret_id_properties).not_to(be_nil)
    end
  end
end
