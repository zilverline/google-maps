# frozen_string_literal: true

require File.expand_path('../spec_helper', __dir__)

describe Google::Maps::Place do
  describe '.find' do
    subject { Google::Maps::Place.find(keyword, country).first }

    context ':nl' do
      before { stub_response('deventer-nl.json') }

      let(:keyword) { 'Deventer' }
      let(:country) { :nl }

      its(:text) { should eq 'Deventer, Nederland' }
      its(:html) { should eq '<strong>Deventer</strong>, Nederland' }

      context 'keyword with escapeable characters' do
        let(:keyword) { 'Deventer \\' }
        let(:country) { :nl }

        its(:text) { should eq 'Deventer, Nederland' }
        its(:html) { should eq '<strong>Deventer</strong>, Nederland' }
        its(:structured_text) { should eq(main: 'Deventer', secondary: 'Nederland') }
      end

      context 'without structured formatting' do
        before { stub_response('deventer-nl-without-structured.json') }

        let(:keyword) { 'Deventer' }
        let(:country) { :nl }

        its(:text) { should eq 'Deventer, Nederland' }
        its(:html) { should eq '<strong>Deventer</strong>, Nederland' }
        its(:structured_text) { should eq(main: nil, secondary: nil) }
      end
    end

    context ':en' do
      before { stub_response('deventer-en.json') }

      let(:keyword) { 'Deventer' }
      let(:country) { :en }

      its(:text) { should eq 'Deventer, Netherlands' }
      its(:html) { should eq '<strong>Deventer</strong>, Netherlands' }
      its(:structured_text) { should eq(main: 'Deventer', secondary: 'Netherlands') }
    end

    context 'only highlights words' do
      before { stub_response 'den-haag-nl.json' }

      let(:keyword) { 'Den . * { } Haag \\' }
      let(:country) { :nl }

      its(:text) { should eq 'Den Haag, Nederland' }
      its(:html) { should eq '<strong>Den</strong> <strong>Haag</strong>, Nederland' }
      its(:structured_text) { should eq(main: 'Den Haag', secondary: 'Nederland') }
    end
  end
end
