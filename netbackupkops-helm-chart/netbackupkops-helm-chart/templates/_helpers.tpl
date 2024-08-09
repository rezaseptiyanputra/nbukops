/* This function is used to fetch storage class of kops pvc*/
{{- define "gen.storageclass" -}}
{{- $namespace := (tpl "{{ .Release.Namespace }}" .) }}
{{- $pvcName := printf "%s-netbackupkops" $namespace }}
{{- if and ( .Release.IsUpgrade ) ( $sc := ( lookup "v1" "PersistentVolumeClaim" .Release.Namespace $pvcName )) -}}
{{- if or ( eq (tpl "{{ .Values.netbackupkops.kopsPvcStorageClass }}" .)  $sc.spec.storageClassName ) ( eq ( default "" .Values.netbackupkops.kopsPvcStorageClass ) "" ) -}}
storageClassName: {{ $sc.spec.storageClassName }}
{{- else -}}
storageClassName: {{ .Values.netbackupkops.kopsPvcStorageClass }}
{{- end -}}
{{- else if not ( eq ( default "" .Values.netbackupkops.kopsPvcStorageClass ) "" ) -}}
storageClassName: {{ .Values.netbackupkops.kopsPvcStorageClass }}
{{- end -}}
{{- end -}}


{{/*
This function validates the replica-count value, or throws an error message.
*/}}
{{- define "getConfigPodReplicaCount" -}}
{{- $replicacount := .Values.nbsetup.replicas -}}
{{- if or (eq (int $replicacount) 0) (eq (int $replicacount) 1) -}}
replicas: {{ .Values.nbsetup.replicas }}
{{- else -}}
{{- fail "Incorrect replica count given for nb-config deployment. Must be either 0 or 1." -}}
{{- end -}}
{{- end -}}

{{/*
This function gets the imagePullSecrets.
*/}}
{{- define "getImagePullSecrets" -}}
{{- with .Values.netbackupkops.imagePullSecrets -}}
imagePullSecrets:
{{- toYaml . | nindent 6 -}}
{{- end -}}
{{- end -}}

{{/*
This function get the imagePullSecret value for passing as arg
*/}}
{{- define "getArgValueForImagePullSecret" -}}
{{- if len .Values.netbackupkops.imagePullSecrets -}}
{{- with (index .Values.netbackupkops.imagePullSecrets 0) -}}
{{ .name }}
{{- end -}}
{{- else -}}
""
{{- end -}}
{{- end -}}
