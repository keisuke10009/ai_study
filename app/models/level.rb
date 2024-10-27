class Level < ActiveHash::Base
  self.data = [
    { id: 1, name: '小学生' },
    { id: 2, name: '中学生' },
    { id: 3, name: '高校生' },
    { id: 4, name: '社会人' }
  ]
 end