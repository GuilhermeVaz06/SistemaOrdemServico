object FDMEstado: TFDMEstado
  OldCreateOrder = False
  Height = 343
  Width = 475
  object DEstado: TDataSource
    DataSet = TEstado
    Left = 34
    Top = 67
  end
  object TEstado: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 33
    Top = 17
    object TEstadocodigo: TIntegerField
      FieldName = 'codigo'
    end
    object TEstadocodigoPais: TIntegerField
      FieldName = 'codigoPais'
    end
    object TEstadocodigoIbge: TStringField
      FieldName = 'codigoIbge'
      Size = 2
    end
    object TEstadonome: TStringField
      FieldName = 'nome'
      Size = 150
    end
    object TEstadocadastradoPor: TStringField
      FieldName = 'cadastradoPor'
      Size = 150
    end
    object TEstadoalteradoPor: TStringField
      FieldName = 'alteradoPor'
      Size = 150
    end
    object TEstadodataCadastro: TStringField
      FieldName = 'dataCadastro'
    end
    object TEstadodataAlteracao: TStringField
      FieldName = 'dataAlteracao'
    end
    object TEstadostatus: TStringField
      FieldName = 'status'
      Size = 1
    end
    object TEstadonomePais: TStringField
      FieldName = 'nomePais'
      Size = 150
    end
  end
end
