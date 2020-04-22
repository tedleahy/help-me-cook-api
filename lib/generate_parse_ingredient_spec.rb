context_title, ingredient_str, expected_name, expected_amount, expected_amount_unit = ARGV

output = "context '#{context_title}' do
      let(:ingredient_str) { '#{ingredient_str}' }
      let(:expected_output) { { name: '#{expected_name}', amount: #{expected_amount}, amount_unit: '#{expected_amount_unit}' } }

      it { is_expected.to eq(expected_output) }
    end"

IO.popen('pbcopy', 'w') { |f| f << output }
