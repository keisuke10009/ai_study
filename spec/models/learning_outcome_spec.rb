require 'rails_helper'

RSpec.describe LearningOutcome, type: :model do
  before do
    user = FactoryBot.create(:user)
    document = FactoryBot.create(:document)
    @learning_outcome = FactoryBot.build(:learning_outcome, user_id: user.id, document_id: document.id)
  end

  describe '学習結果' do
    context '新規登録できるとき' do
      it '正常に登録登録できる' do
        expect(@learning_outcome).to be_valid
      end
    end
    context '新規登録できないとき' do
      it 'user_idが紐ついていなければ購入できない' do
        @learning_outcome.user_id = ''
        @learning_outcome.valid?
        expect(@learning_outcome.errors.full_messages).to include("User must exist")
      end
      it 'document_idが紐ついていなければ購入できない' do
        @learning_outcome.document_id = ''
        @learning_outcome.valid?
        expect(@learning_outcome.errors.full_messages).to include("Document must exist")
      end
      it 'sum_rel_idが空では登録できない' do
        @learning_outcome.sum_rel_id = ''
        @learning_outcome.valid?
        expect(@learning_outcome.errors.full_messages).to include("Sum rel can't be blank")
      end
      it 'textが空では登録できない' do
        @learning_outcome.text = ''
        @learning_outcome.valid?
        expect(@learning_outcome.errors.full_messages).to include("Text can't be blank")
      end
      it 'scoreが空では登録できない' do
        @learning_outcome.score = ''
        @learning_outcome.valid?
        expect(@learning_outcome.errors.full_messages).to include("Score can't be blank")
      end
      it 'assessmentが空では登録できない' do
        @learning_outcome.assessment = ''
        @learning_outcome.valid?
        expect(@learning_outcome.errors.full_messages).to include("Assessment can't be blank")
      end
    end
  end
end
