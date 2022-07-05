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
        expected_role_name, output(:root, 'secret_id')
      )
    end

    before(:context) do
      provision(:root)
    end

    after(:context) do
      destroy(:root)
    end

    it 'creates a default secret ID for the role' do
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
  end
end
