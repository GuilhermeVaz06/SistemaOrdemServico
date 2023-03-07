object FDMFuncao: TFDMFuncao
  OldCreateOrder = False
  Height = 343
  Width = 475
  object DFuncao: TDataSource
    DataSet = TFuncao
    Left = 34
    Top = 67
  end
  object TFuncao: TFDMemTable
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
    object TFuncaocodigo: TIntegerField
      FieldName = 'codigo'
    end
    object TFuncaodescricao: TStringField
      FieldName = 'descricao'
      Size = 150
    end
    object TFuncaovalorHoraNormal: TFloatField
      FieldName = 'valorHoraNormal'
      currency = True
    end
    object TFuncaovalorHora50: TFloatField
      FieldName = 'valorHora50'
      currency = True
    end
    object TFuncaovalorHora100: TFloatField
      FieldName = 'valorHora100'
      currency = True
    end
    object TFuncaovalorAdicionalNoturno: TFloatField
      FieldName = 'valorAdicionalNoturno'
      currency = True
    end
    object TFuncaostatus: TStringField
      FieldName = 'status'
      Size = 1
    end
    object TFuncaocadastradoPor: TStringField
      FieldName = 'cadastradoPor'
      Size = 150
    end
    object TFuncaoalteradoPor: TStringField
      FieldName = 'alteradoPor'
      Size = 150
    end
    object TFuncaodataCadastro: TStringField
      FieldName = 'dataCadastro'
    end
    object TFuncaodataAlteracao: TStringField
      FieldName = 'dataAlteracao'
    end
  end
end
