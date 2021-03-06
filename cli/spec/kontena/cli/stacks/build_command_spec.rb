require_relative "../../../spec_helper"
require "kontena/cli/stacks/build_command"

describe Kontena::Cli::Stacks::BuildCommand do

  let(:subject) do
    described_class.new(File.basename($0))
  end

  describe '#execute' do
    let(:stack) do
      {
        'name' => 'stack-a',
        'stack' => 'user/stack-a',
        'version' => '1.0.0',
        'services' => [
          service
        ]
      }
    end

    let(:service) do
      {
        'name' => 'test',
        'image' => 'registry.kontena.local/test:latest',
        'build' => {
          'context' => File.expand_path('.')
        }
      }
    end

    describe '#execute' do
      before(:each) do
        allow(subject).to receive(:require_config_file).with('kontena.yml').and_return(true)
        allow(subject).to receive(:stack_from_yaml).with('kontena.yml').and_return(stack)
        allow(subject).to receive(:system).and_return(true)
      end

      it 'requires config file' do
        expect(subject).to receive(:require_config_file).with('kontena.yml').and_return(true)
        subject.run([])
      end

      it 'reads stack file' do
        expect(subject).to receive(:stack_from_yaml).with('kontena.yml').and_return(stack)
        subject.run([])
      end

      it 'builds docker image' do
        expect(subject).to receive(:system).with('docker', 'build', '-t', 'registry.kontena.local/test:latest', '--pull', File.expand_path('.'))
        subject.run([])
      end

      it 'pushes docker image' do
        expect(subject).to receive(:system).with('docker', 'push', 'registry.kontena.local/test:latest')
        subject.run([])
      end
    end
  end
end
