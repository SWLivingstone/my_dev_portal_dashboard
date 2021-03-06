require 'rails_helper'

RSpec.describe Portfolio, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:attributes) do
    { url: 'testing',
      color_one: '#ffffff',
      color_two: '#ffffff',
      color_three: '#ffffff',
      color_four: '#ffffff',
      theme: 'default' }
  end

  describe 'Create Portfolio' do
    it 'creates a new portfolio' do
      user.portfolios.create(attributes)
      expect(user.portfolios.first.url).to eq('testing')
    end
  end

  describe 'Update Portfolio' do
    let(:portfolio) { user.portfolios.create(attributes) }
    it 'edits portfolio URL' do
      portfolio.update(url: 'test')
      expect(user.portfolios.first.url).to eq('test')
    end
  end

  describe '#user' do
    it { should belong_to(:user) }
  end

  describe '#url' do
    it { should validate_presence_of(:url) }
    it { should validate_uniqueness_of(:url) }
    it do
      should validate_length_of(:url)
        .is_at_least(3)
    end
    it 'should only containe lowercase alphanumeric characters' do
      record = Portfolio.new
      invalid_characters = %w[! @ A B # $ % ^ & * ( ) = + / \ { } [ ] < > ' " ` ~]
      invalid_characters.each do |char|
        record.url = "test#{char}"
        record.valid?
        expect(record.errors[:url]).to eq(['must only contain lowercase alphanumeric characters, hyphens, or underscores'])
      end
      record.url = 'myurl'
      record.valid?
      expect(record.errors[:url]).to eq([])
    end
  end

  describe '#color_one' do
    is_valid_css_hex_color(:color_one, Portfolio.new)
  end

  describe '#color_two' do
    is_valid_css_hex_color(:color_two, Portfolio.new)
  end

  describe '#color_three' do
    is_valid_css_hex_color(:color_three, Portfolio.new)
  end

  describe '#color_three' do
    is_valid_css_hex_color(:color_four, Portfolio.new)
  end

  describe '#theme' do
    it do
      should validate_inclusion_of(:theme)
        .in_array(Themes.array)
    end
  end
end
