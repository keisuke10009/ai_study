class Category < ActiveHash::Base
  self.data = [
    { id: 1, name: '小説' },
    { id: 2, name: '評論文' },
    { id: 3, name: 'エッセイ' },
    { id: 4, name: '説明文' }
  ]
 end