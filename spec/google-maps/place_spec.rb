require File.expand_path('../../spec_helper', __FILE__)

describe Google::Maps::Place do
  describe ".find" do
    context ":nl" do
      before{ stub_response("deventer-nl.json") }

      subject { Google::Maps::Place.find(keyword, country).first }

      let(:keyword) { "Deventer" }
      let(:country) { :nl }

      its(:text) { should eq "Deventer, Nederland" }
      its(:html) { should eq "<strong>Deventer</strong>, Nederland" }

      context "keyword with escapeable characters" do
        let(:keyword) { "Deventer \\" }
        let(:country) { :nl }

        its(:text) { should eq "Deventer, Nederland" }
        its(:html) { should eq "<strong>Deventer</strong>, Nederland" }
      end
    end

    context ":en" do
      before { stub_response("deventer-en.json") }

      subject { Google::Maps::Place.find(keyword, country).first }

      let(:keyword) { "Deventer" }
      let(:country) { :en }

      its(:text) { should eq "Deventer, The Netherlands" }
      its(:html) { should eq "<strong>Deventer</strong>, The Netherlands" }
    end
  end
end
