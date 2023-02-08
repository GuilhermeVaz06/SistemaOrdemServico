object FDMTipoEndereco: TFDMTipoEndereco
  OldCreateOrder = False
  Height = 343
  Width = 475
  object DTipoEndereco: TDataSource
    DataSet = TTipoEndereco
    Left = 34
    Top = 67
  end
  object TTipoEndereco: TFDMemTable
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
    object TTipoEnderecocodigo: TIntegerField
      FieldName = 'codigo'
    end
    object TTipoEnderecodescricao: TStringField
      FieldName = 'descricao'
      Size = 150
    end
    object TTipoEnderecostatus: TStringField
      FieldName = 'status'
      Size = 1
    end
    object TTipoEnderecocadastradoPor: TStringField
      FieldName = 'cadastradoPor'
      Size = 150
    end
    object TTipoEnderecoalteradoPor: TStringField
      FieldName = 'alteradoPor'
      Size = 150
    end
    object TTipoEnderecodataCadastro: TStringField
      FieldName = 'dataCadastro'
    end
    object TTipoEnderecodataAlteracao: TStringField
      FieldName = 'dataAlteracao'
    end
  end
end
