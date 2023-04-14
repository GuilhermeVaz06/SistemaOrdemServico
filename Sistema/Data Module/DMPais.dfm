object FDMPais: TFDMPais
  OldCreateOrder = False
  Height = 343
  Width = 475
  object DPais: TDataSource
    DataSet = TPais
    Left = 34
    Top = 67
  end
  object TPais: TFDMemTable
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
    object TPaiscodigo: TIntegerField
      FieldName = 'codigo'
    end
    object TPaiscodigoIbge: TStringField
      FieldName = 'codigoIbge'
      Size = 4
    end
    object TPaisnome: TStringField
      FieldName = 'nome'
      Size = 150
    end
    object TPaiscadastradoPor: TStringField
      FieldName = 'cadastradoPor'
      Size = 150
    end
    object TPaisalteradoPor: TStringField
      FieldName = 'alteradoPor'
      Size = 150
    end
    object TPaisdataCadastro: TStringField
      FieldName = 'dataCadastro'
    end
    object TPaisdataAlteracao: TStringField
      FieldName = 'dataAlteracao'
    end
    object TPaisstatus: TStringField
      FieldName = 'status'
      Size = 1
    end
  end
end
