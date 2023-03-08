object FDMGrupo: TFDMGrupo
  OldCreateOrder = False
  Height = 343
  Width = 475
  object DGrupo: TDataSource
    DataSet = TGrupo
    Left = 34
    Top = 67
  end
  object TGrupo: TFDMemTable
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
    object TGrupocodigo: TIntegerField
      FieldName = 'codigo'
    end
    object TGrupodescricao: TStringField
      FieldName = 'descricao'
      Size = 150
    end
    object TGrupostatus: TStringField
      FieldName = 'status'
      Size = 1
    end
    object TGrupocadastradoPor: TStringField
      FieldName = 'cadastradoPor'
      Size = 150
    end
    object TGrupoalteradoPor: TStringField
      FieldName = 'alteradoPor'
      Size = 150
    end
    object TGrupodataCadastro: TStringField
      FieldName = 'dataCadastro'
    end
    object TGrupodataAlteracao: TStringField
      FieldName = 'dataAlteracao'
    end
  end
end
