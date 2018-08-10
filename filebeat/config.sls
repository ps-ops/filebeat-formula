#!py

def run():
    filebeat_config = __pillar__.get('filebeat')

    if filebeat_config:
        env = __grains__['env']
        filebeat_config['fields']['env'] = env
        filebeat_config['output.elasticsearch']['index'] += '-' + env
        filebeat_config['setup.template'] = {
            'pattern': filebeat_config['output.elasticsearch']['index'] + '-*',
            'name': filebeat_config['output.elasticsearch']['index']
        }

        return {
            'filebeat-config': {
                'file.serialize': [
                    {'name': '/etc/filebeat/filebeat.yml'},
                    {'mode': '644'},
                    {'user': 'root'},
                    {'group': 'root'},
                    {'dataset': filebeat_config},
                    {'formatter': 'yaml'}
                ]
            }
        }
