object DataModule1: TDataModule1
  OldCreateOrder = False
  Left = 211
  Top = 114
  Height = 150
  Width = 215
  object TableCursos: TTable
    DatabaseName = 'Reporte'
    IndexName = 'ByNum'
    TableName = 'Cursos.db'
    Left = 24
    Top = 16
  end
  object TableEstudiantes: TTable
    DatabaseName = 'Reporte'
    IndexName = 'ByPromedio'
    TableName = 'Estudiantes.db'
    Left = 104
    Top = 16
  end
  object TableGrupos: TTable
    DatabaseName = 'Reporte'
    IndexName = 'ByNum'
    TableName = 'Grupos.db'
    Left = 24
    Top = 72
  end
  object TableSinPlaza: TTable
    DatabaseName = 'Reporte'
    IndexName = 'ByGrupo'
    TableName = 'EstudiantesSinPlaza.DB'
    Left = 104
    Top = 72
  end
end
