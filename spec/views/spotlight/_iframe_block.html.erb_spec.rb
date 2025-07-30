# frozen_string_literal: true

RSpec.describe 'spotlight/sir_trevor/blocks/_iframe_block.html.erb', type: :view do
  let(:p) { 'spotlight/sir_trevor/blocks/iframe_block' }
  let(:block) do
    OpenStruct.new
  end

  it 'renders iframes' do
    block.code = "<iframe src='xyz'></iframe>"
    render partial: p, locals: { iframe_block: block }
    expect(rendered).to have_selector 'iframe[src="xyz"]'
  end

  it 'strips extra markup from the code' do
    block.code = '<a><b></b></a>'
    render partial: p, locals: { iframe_block: block }
    expect(rendered).to be_blank
  end

  it 'renders iframe and strips extra markup from the code' do
    block.code = "<a><b></b></a><iframe src='xyz'></iframe>"
    render partial: p, locals: { iframe_block: block }
    expect(rendered).to have_selector 'iframe[src="xyz"]'
  end

  # Tests customization that adds style as an allowed attribute in the iframe block
  it 'renders iframes with style attribute' do
    block.code = "<iframe style='width:560px;height:500px;'></iframe>"
    render partial: p, locals: { iframe_block: block }
    expect(rendered).to have_selector 'iframe[style="width:560px;height:500px;"]'
  end

  it 'renders iframes with style attribute and strips disallowed attribute' do
    block.code = "<iframe class='xyz' style='width:560px;height:500px;'></iframe>"
    render partial: p, locals: { iframe_block: block }
    expect(rendered).to have_selector 'iframe[style="width:560px;height:500px;"]'
  end

  it 'strips style attribute function not allowed by Rails sanitizer' do
    block.code = "<iframe style='background:url()'></iframe>"
    render partial: p, locals: { iframe_block: block }
    expect(rendered).not_to have_selector 'iframe[style="background:url();"]'
  end
end
