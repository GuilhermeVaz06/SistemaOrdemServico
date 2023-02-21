object FDMTipoDocumento: TFDMTipoDocumento
  OldCreateOrder = False
  Height = 343
  Width = 475
  object DTipoDocumento: TDataSource
    DataSet = TTipoDocumento
    Left = 34
    Top = 67
  end
  object TTipoDocumento: TFDMemTable
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
    object TTipoDocumentocodigo: TIntegerField
      FieldName = 'codigo'
    end
    object TTipoDocumentodescricao: TStringField
      FieldName = 'descricao'
    end
    object TTipoDocumentoqtdeCaracteres: TIntegerField
      FieldName = 'qtdeCaracteres'
    end
    object TTipoDocumentomascara: TStringField
      FieldName = 'mascara'
      Size = 30
    end
    object TTipoDocumentostatus: TStringField
      FieldName = 'status'
      Size = 1
    end
    object TTipoDocumentocadastradoPor: TStringField
      FieldName = 'cadastradoPor'
      Size = 150
    end
    object TTipoDocumentoalteradoPor: TStringField
      FieldName = 'alteradoPor'
      Size = 150
    end
    object TTipoDocumentodataCadastro: TStringField
      FieldName = 'dataCadastro'
    end
    object TTipoDocumentodataAlteracao: TStringField
      FieldName = 'dataAlteracao'
    end
  end
end
