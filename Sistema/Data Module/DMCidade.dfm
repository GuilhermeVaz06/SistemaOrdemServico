object FDMCidade: TFDMCidade
  OldCreateOrder = False
  Height = 343
  Width = 475
  object DCidade: TDataSource
    DataSet = TCidade
    Left = 34
    Top = 67
  end
  object TCidade: TFDMemTable
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
    object TCidadecodigo: TIntegerField
      FieldName = 'codigo'
    end
    object TCidadecodigoEstado: TIntegerField
      FieldName = 'codigoEstado'
    end
    object TCidadenomeEstado: TStringField
      FieldName = 'nomeEstado'
      Size = 150
    end
    object TCidadecodigoPais: TIntegerField
      FieldName = 'codigoPais'
    end
    object TCidadenomePais: TStringField
      FieldName = 'nomePais'
      Size = 150
    end
    object TCidadecodigoIbge: TStringField
      FieldName = 'codigoIbge'
      Size = 7
    end
    object TCidadenome: TStringField
      FieldName = 'nome'
      Size = 150
    end
    object TCidadecadastradoPor: TStringField
      FieldName = 'cadastradoPor'
      Size = 150
    end
    object TCidadealteradoPor: TStringField
      FieldName = 'alteradoPor'
      Size = 150
    end
    object TCidadedataCadastro: TStringField
      FieldName = 'dataCadastro'
    end
    object TCidadedataAlteracao: TStringField
      FieldName = 'dataAlteracao'
    end
    object TCidadestatus: TStringField
      FieldName = 'status'
      Size = 1
    end
  end
end
